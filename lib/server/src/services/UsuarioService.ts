import { PrismaClient } from "@prisma/client";
import * as bcrypt from "bcrypt";
import { CriarUsuarioDTO, LogarUsuarioDTO } from "../schemas/usuario.schema";
import * as jwt from "jsonwebtoken";

export default class UsuarioService {
  private prisma: PrismaClient;
  private saltRounds = 12;

  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  public async cadastrarUsuario(userInfos: CriarUsuarioDTO) {
    const emailExistente = await this.prisma.usuario.findFirst({
      where: { cd_email_usuario: userInfos.cd_email_usuario },
    });

    if (emailExistente) {
      throw new Error("Email já cadastrado");
    }

    let dadosParaSalvar: any = { ...userInfos };

    if (userInfos.tipo_usuario === "pf") {
      dadosParaSalvar.ch_cpf_usuario = userInfos.ch_cpf_usuario;
      const cpfExistente = await this.prisma.usuario.findFirst({
        where: { ch_cpf_usuario: dadosParaSalvar.ch_cpf_usuario },
      });
      if (cpfExistente) {
        throw new Error("CPF já cadastrado");
      }
    } else {
      dadosParaSalvar.ch_cnpj_usuario = userInfos.ch_cnpj_usuario;
      const cnpjExistente = await this.prisma.usuario.findFirst({
        where: { ch_cnpj_usuario: dadosParaSalvar.ch_cnpj_usuario },
      });
      if (cnpjExistente) {
        throw new Error("CNPJ já cadastrado");
      }
    }

    // Remove o campo genérico que não existe no banco
    delete dadosParaSalvar.ch_documento_usuario;

    const senhaCriptografada = await bcrypt.hash(
      userInfos.cd_senha_usuario,
      this.saltRounds
    );
    dadosParaSalvar.cd_senha_usuario = senhaCriptografada;

    const novoUsuario = await this.prisma.usuario.create({
      data: dadosParaSalvar,
    });

    const { cd_senha_usuario, ...usuarioSemSenha } = novoUsuario;
    return usuarioSemSenha;
  }

  public async autenticarUsuario(dadosLogin: LogarUsuarioDTO) {
    const { user_email, user_password } = dadosLogin;

    const usuario = await this.prisma.usuario.findFirst({
      where: { cd_email_usuario: user_email },
    });

    if (!usuario) {
      throw new Error("Email ou senha inválidos");
    }

    const senhaCorreta = await bcrypt.compare(
      user_password,
      usuario.cd_senha_usuario
    );

    if (!senhaCorreta) {
      throw new Error("Email ou senha inválidos");
    }

    const jwtPayload = {
      id: usuario.id,
      email: usuario.cd_email_usuario,
      is_admin: usuario.fg_admin,
    };

    const jwtSecret = process.env.JWT_SECRET! as string;

    const token = jwt.sign(jwtPayload, jwtSecret, {
      expiresIn: "2h",
    });

    const { cd_senha_usuario, ...usuarioSemSenha } = usuario;
    return { user: usuarioSemSenha, token: token };
  }

  public async buscarUsuarios() {
    const usuarios = await this.prisma.usuario.findMany();

    const usuariosSemSenha = usuarios.map((usuario) => {
      const { cd_senha_usuario, ...usuarioSemSenha } = usuario;
      return usuarioSemSenha;
    });

    return usuariosSemSenha;
  }
}
