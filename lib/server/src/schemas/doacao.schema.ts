import { z } from "zod/v3";

// Schema para um único alimento que está sendo doado
const alimentoDoadoSchema = z.object({
  alimento_id: z.string({ required_error: "O ID do alimento é obrigatório." }),
  qt_alimento_doacao: z
    .number({ required_error: "A quantidade doada é obrigatória." })
    .int()
    .positive("A quantidade deve ser um número positivo."),
});

// Schema principal para registrar uma doação
export const registrarDoacaoSchema = z.object({
  infos_doacao: z.object({
    usuario_doacao: z.string({
      required_error: "O ID do usuário doador é obrigatório.",
    }),
    cd_campanha_doacao: z.string({
      required_error: "O ID da campanha é obrigatório.",
    }),
  }),
  alimentos_doacao: z
    .array(alimentoDoadoSchema)
    .min(1, "É necessário doar pelo menos um alimento."),
});

export type RegistrarDoacaoDTO = z.infer<typeof registrarDoacaoSchema>;
