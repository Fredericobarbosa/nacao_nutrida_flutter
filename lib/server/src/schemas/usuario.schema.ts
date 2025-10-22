// Em src/schemas/usuario.schema.ts
import { z } from "zod/v3";
import { cpf, cnpj } from "cpf-cnpj-validator";

export const criarUsuarioSchema = z.object({
  // O corpo da requisição deve tem a chave 'user_infos'
  user_infos: z
    .object({
      tipo_usuario: z.enum(["pf", "pj"], {
        errorMap: () => ({
          message: "O tipo de usuário deve ser 'pf' ou 'pj'.",
        }),
      }),
      nm_usuario: z
        .string()
        .min(1, "O nome é obrigatório.")
        .min(3, "O nome deve ter no mínimo 3 caracteres.")
        .transform((name) => {
          return name
            .trim()
            .split(" ")
            .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
            .join(" ");
        }),

      // Campos de documento opcionais aqui, pq a validação final virá do superRefine
      ch_cpf_usuario: z.string().optional(),
      ch_cnpj_usuario: z.string().optional(),

      cd_email_usuario: z
        .string()
        .min(1, "O e-mail é obrigatório.")
        .email("Insira um e-mail válido."),

      nr_celular_usuario: z
        .string()
        .min(1, "O número de celular é obrigatório."),

      cd_senha_usuario: z
        .string()
        .min(6, "A senha deve ter no mínimo 6 caracteres."),

      sg_estado_usuario: z.string().min(1, "O estado é obrigatório."),
      nm_cidade_usuario: z.string().min(1, "A cidade é obrigatória."),
      dt_nascimento_usuario: z.string().optional(), // Opcional aqui, validado abaixo
      cd_foto_usuario: z.string().optional(),
    })
    .superRefine((data, ctx) => {
      // Validação condicional com base no 'tipo_usuario'
      if (data.tipo_usuario === "pf") {
        if (!data.ch_cpf_usuario) {
          ctx.addIssue({
            code: z.ZodIssueCode.custom,
            path: ["ch_cpf_usuario"],
            message: "O CPF é obrigatório para pessoa física.",
          });
        } else if (!cpf.isValid(data.ch_cpf_usuario)) {
          ctx.addIssue({
            code: z.ZodIssueCode.custom,
            path: ["ch_cpf_usuario"],
            message: "CPF inválido.",
          });
        }

        if (!data.dt_nascimento_usuario) {
          ctx.addIssue({
            code: z.ZodIssueCode.custom,
            path: ["dt_nascimento_usuario"],
            message: "A data de nascimento é obrigatória para pessoa física.",
          });
        }
      }

      if (data.tipo_usuario === "pj") {
        if (!data.ch_cnpj_usuario) {
          ctx.addIssue({
            code: z.ZodIssueCode.custom,
            path: ["ch_cnpj_usuario"],
            message: "O CNPJ é obrigatório para pessoa jurídica.",
          });
        } else if (!cnpj.isValid(data.ch_cnpj_usuario)) {
          ctx.addIssue({
            code: z.ZodIssueCode.custom,
            path: ["ch_cnpj_usuario"],
            message: "CNPJ inválido.",
          });
        }
      }
    }),
});
export type CriarUsuarioDTO = z.infer<typeof criarUsuarioSchema>["user_infos"];

export const loginUsuarioSchema = z.object({
  user_email: z
    .string()
    .min(1, "O e-mail é obrigatório.")
    .email("Insira um e-mail válido."),
  user_password: z
    .string()
    .min(6, "Sua senha deve ter no mínimo 6 caracteres."),
});
export type LogarUsuarioDTO = z.infer<typeof loginUsuarioSchema>;
