import { Request, Response } from "express";
import ChatService from "../services/ChatService";

export default class ChatController {
  private chatService: ChatService;

  constructor(chatService: ChatService) {
    this.chatService = chatService;
    this.listarConversas = this.listarConversas.bind(this);
    this.criarConversa = this.criarConversa.bind(this);
    this.listarMensagens = this.listarMensagens.bind(this);
    this.enviarMensagem = this.enviarMensagem.bind(this);
    this.excluirConversa = this.excluirConversa.bind(this);
  }

  async listarConversas(req: Request, res: Response) {
    const userId = req.query.userId as string;
    if (!userId) return res.status(400).json({ error: "userId obrigatório" });

    try {
      const conversations = await this.chatService.listarConversas(userId);
      res.json(conversations);
    } catch (error: any) {
      if (error.message === "Usuário nao encontrado") {
        return res.status(404).json({ error: "Usuário nao encontrado" });
      }
      console.error("Erro ao listar conversas:", error);
      res.status(500).json({ error: "Erro ao listar conversas" });
    }
  }

  async criarConversa(req: Request, res: Response) {
    const { userId, adminId } = req.body;
    if (!userId || !adminId) {
      return res.status(400).json({ error: "userId e adminId obrigatórios" });
    }

    try {
      const conversation = await this.chatService.criarConversa(
        userId,
        adminId
      );
      res.json(conversation);
    } catch (error: any) {
      console.error("Erro ao criar conversa:", error);
      res.status(500).json({ error: "Erro ao criar conversa" });
    }
  }

  async listarMensagens(req: Request, res: Response) {
    const conversationId = req.query.conversationId as string;
    const userId = req.query.userId as string;
    if (!conversationId || !userId) {
      return res
        .status(400)
        .json({ error: "conversationId e userId obrigatórios" });
    }

    try {
      const messages = await this.chatService.listarMensagens(
        conversationId,
        userId
      );
      res.json(messages);
    } catch (error: any) {
      if (error.message === "Conversa nao encontrada") {
        return res.status(404).json({ error: "Conversa nao encontrada" });
      }
      if (error.message === "Usuário nao encontrado") {
        return res.status(404).json({ error: "Usuário nao encontrado" });
      }
      if (error.message === "Acesso negado") {
        return res.status(403).json({ error: "Acesso negado" });
      }
      console.error("Erro ao listar mensagens:", error);
      res.status(500).json({ error: "Erro ao listar mensagens" });
    }
  }

  async enviarMensagem(req: Request, res: Response) {
    const { conversationId, senderId, text } = req.body;
    if (!conversationId || !senderId || !text) {
      return res.status(400).json({ error: "Campos obrigatórios" });
    }

    try {
      const message = await this.chatService.enviarMensagem(
        conversationId,
        senderId,
        text
      );
      res.json(message);
    } catch (error: any) {
      console.error("Erro ao enviar mensagem:", error);
      res.status(500).json({ error: "Erro ao enviar mensagem" });
    }
  }

  async excluirConversa(req: Request, res: Response) {
    const conversationId = req.params.id;
    const userId = req.query.userId as string;
    if (!conversationId || !userId) {
      return res
        .status(400)
        .json({ error: "conversationId e userId obrigatórios" });
    }

    try {
      const conversation = await this.chatService.excluirConversa(
        conversationId,
        userId
      );
      res.json(conversation);
    } catch (error: any) {
      if (error.message === "Conversa nao encontrada") {
        return res.status(404).json({ error: "Conversa nao encontrada" });
      }
      if (error.message === "Usuário nao encontrado") {
        return res.status(404).json({ error: "Usuário nao encontrado" });
      }
      if (error.message === "Acesso negado") {
        return res.status(403).json({ error: "Acesso negado" });
      }
      console.error("Erro ao excluir conversa:", error);
      res.status(500).json({ error: "Erro ao excluir conversa" });
    }
  }
}
