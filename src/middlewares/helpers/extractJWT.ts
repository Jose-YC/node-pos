import { Request } from "express";

export const extractJWT = (req: Request): string | null => {
    const authHeader = req.headers.authorization;

    if (authHeader && authHeader.startsWith("Bearer ")){
        const token = authHeader.slice(7);
        if (token.trim()) return token
    }

    const xtoken = req.header("x-token");
    
    return xtoken && xtoken.trim() ? xtoken : null;
}