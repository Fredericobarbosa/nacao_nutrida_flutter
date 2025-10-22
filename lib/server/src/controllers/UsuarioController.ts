import { Request, Response } from "express";
import UsuarioService from "../services/UsuarioService";

export default class UsuarioController {
  private usuarioService: UsuarioService;

  constructor(usuarioService: UsuarioService) {
    this.usuarioService = usuarioService;
    this.create = this.create.bind(this);
    this.login = this.login.bind(this);
    this.getUsers = this.getUsers.bind(this);
    this.getProfile = this.getProfile.bind(this);
  }

  public async create(req: Request, res: Response): Promise<Response> {
    try {
      const userInfos = req.body.user_infos;

      const novoUsuario = await this.usuarioService.cadastrarUsuario(userInfos);

      return res.status(201).json(novoUsuario);
    } catch (error: any) {
      console.error("Erro ao registrar usuário:", error.message);

      if (error instanceof Error) {
        return res.status(400).json({ message: error.message });
      }

      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  }

  public async login(req: Request, res: Response): Promise<Response> {
    try {
      const dadosLogin = req.body;

      const { user, token } = await this.usuarioService.autenticarUsuario(
        dadosLogin
      );

      return res.status(200).json({
        user,
        token,
        authenticated: true,
        message: "Usuário autenticado",
      });
    } catch (error: any) {
      if (error instanceof Error) {
        return res.status(401).json({
          user: null,
          authenticated: false,
          message: error.message,
        });
      }

      console.error("Erro durante o login:", error);
      return res.status(500).json({ message: "Erro interno do servidor" });
    }
  }

  public async getUsers(req: Request, res: Response): Promise<Response> {
    try {
      const usuarios = await this.usuarioService.buscarUsuarios();
      return res.status(200).json(usuarios);
    } catch (error: any) {
      console.error("Erro ao buscar usuários:", error);
      return res.status(500).json({ message: "Erro ao buscar usuários" });
    }
  }

  public async getProfile(req: Request, res: Response): Promise<Response> {
    const usuarioLogado = req.user;

    if (!usuarioLogado) {
      return res.status(401).json({ message: "Usuário não autenticado" });
    }

    return res.status(200).json(usuarioLogado);
  }
}
