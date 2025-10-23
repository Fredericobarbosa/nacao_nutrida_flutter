import { PrismaClient } from "@prisma/client";

export default class ChatService {
  private prisma: PrismaClient;
  constructor(prisma: PrismaClient) {
    this.prisma = prisma;
  }

  async listarConversas(userId: string) {
    const usuario = await this.prisma.usuario.findUnique({
      where: { id: userId },
    });
    if (!usuario) throw new Error("Usuário nao encontrado");

    let conversations = [];
    if (usuario.fg_admin === 1) {
      // Admin: vê todas as conversas
      conversations = await this.prisma.conversation.findMany({
        orderBy: { updatedAt: "desc" },
      });
    } else {
      // Usuário comum: só vê conversas em que participa
      conversations = await this.prisma.conversation.findMany({
        where: { users: { has: userId } },
        orderBy: { updatedAt: "desc" },
      });
    }

    return conversations;
  }

  async criarConversa(userId: string, adminId: string) {
    const conversation = await this.prisma.conversation.create({
      data: {
        users: [userId, adminId],
        lastMessage: "",
        updatedAt: new Date(),
      },
    });
    return conversation;
  }

  async listarMensagens(conversationId: string, userId: string) {
    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
    });
    if (!conversation) throw new Error("Conversa nao encontrada");
    // Busca o usuário
    const usuario = await this.prisma.usuario.findUnique({
      where: { id: userId },
    });
    if (!usuario) throw new Error("Usuário nao encontrado");
    // Permite acesso se for participante ou admin
    if (!conversation.users.includes(userId) && usuario.fg_admin !== 1)
      throw new Error("Acesso negado");
    const messages = await this.prisma.message.findMany({
      where: { conversationId },
      orderBy: { createdAt: "asc" },
    });

    return messages;
  }

  async enviarMensagem(conversationId: string, senderId: string, text: string) {
    const message = await this.prisma.message.create({
      data: {
        conversationId,
        senderId,
        text,
        createdAt: new Date(),
      },
    });
    // Atualiza lastMessage na conversa
    await this.prisma.conversation.update({
      where: { id: conversationId },
      data: { lastMessage: text, updatedAt: new Date() },
    });
    return message;
  }

  async excluirConversa(conversationId: string, userId: string) {
    // Verifica se o usuário é participante da conversa
    const conversation = await this.prisma.conversation.findUnique({
      where: { id: conversationId },
    });
    if (!conversation) throw new Error("Conversa não encontrada");
    if (!conversation.users.includes(userId)) throw new Error("Acesso negado");

    // Exclui mensagens associadas
    await this.prisma.message.deleteMany({ where: { conversationId } });
    // Exclui a conversa
    await this.prisma.conversation.delete({ where: { id: conversationId } });
    return { success: true };
  }
}
