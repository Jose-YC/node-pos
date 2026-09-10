import { LoginRequestDto, AuthResponseDto, RegisterRequestDto } from '../dto';
import { bcryptjsAdapter, jwtAdapter, CustomError } from '../../../shared';
import { AuthResponseMapper } from '../mapper/auth.mapper';
import { RegisterRaw } from '../interface/auth.interface';
import { prisma } from '../../../config';

export class AuthDatasource {

    async login(login: LoginRequestDto): Promise<AuthResponseDto>{
        const user = await prisma.user.findFirst({
            select:{
                id:true,
                name:true,
                email:true,
                password:true,
                image_url:true,
            },
            where:{
                email:login.email,
                deleted_at: null
            }}
        );
        if (!user) throw CustomError.badRequest('Incorrect email or password');

        const validPasword = bcryptjsAdapter.compare(login.password, user.password);
        if (!validPasword) throw CustomError.badRequest('Incorrect email or password');

        const token = await jwtAdapter.generatetJWT<string>({id: user.id});
        if (!token) throw CustomError.internalServer('Error creating token');

        return AuthResponseMapper.toDto(token, {id: user.id, name: user.name, email: user.email, image: user.image_url || undefined });
    }
    
    async register(register:RegisterRequestDto): Promise<AuthResponseDto> {

        const password = await bcryptjsAdapter.hash(register.password);

        const [ user, ...rest] = await prisma.$queryRaw<RegisterRaw[]>`
            SELECT * FROM fc_RegisterUser(${register.email}, ${register.name}, ${password})
        `;
        
        const token = await jwtAdapter.generatetJWT<string>({id: user.id});
        if (!token) { throw CustomError.internalServer('Error creating token')};

        return AuthResponseMapper.toDto(token, {id: user.id, name: user.name, email: user.email});
    }
    
    async refresh(token: string): Promise<string> {
        const payload = await jwtAdapter.decodeJWT<{id:number, iat:number, exp:number}>(token);
        if (!payload) throw CustomError.unAuthorized('Invalid token');

        const now = Math.floor(Date.now() / 1000);
        if (payload.exp && now < payload.exp) return token;

        const newToken = await jwtAdapter.generatetJWT<string>({id: payload.id});
        if (!newToken) throw CustomError.internalServer('Error creating token');
        
        return newToken;
    }
}