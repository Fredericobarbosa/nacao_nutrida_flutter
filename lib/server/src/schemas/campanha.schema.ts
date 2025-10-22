import { z } from "zod/v3";

// Schema para um único alimento dentro da campanha
const alimentoCampanhaSchema = z.object({
  id: z.string({ required_error: "O ID do alimento é obrigatório." }),
  qt_alimento_meta: z
    .number({ required_error: "A meta do alimento é obrigatória." })
    .int()
    .positive("A meta deve ser um número positivo."),
});

// Schema principal para a criação da campanha
export const criarCampanhaSchema = z.object({
  infos_campanha: z.object({
    usuario_id: z.string({
      required_error: "O ID do usuário é obrigatório.",
    }),
    nm_titulo_campanha: z
      .string()
      .min(1, "O título da campanha é obrigatório."),
    dt_encerramento_campanha: z
      .string({ required_error: "A data de encerramento é obrigatória." })
      .transform((dateStr) => new Date(dateStr)), // Converte string para Date
    nm_cidade_campanha: z.string().min(1, "A cidade é obrigatória."),
    sg_estado_campanha: z.string().min(1, "O estado é obrigatório."),
    ds_acao_campanha: z.string().min(1, "A descrição é obrigatória."),
    cd_imagem_campanha: z.string().optional().default("default.png"),
    fg_campanha_ativa: z.boolean().default(true),
  }),
  alimentos_campanha: z
    .array(alimentoCampanhaSchema)
    .min(1, "A campanha deve ter pelo menos um alimento."),
});

export type CriarCampanhaDTO = z.infer<typeof criarCampanhaSchema>;
