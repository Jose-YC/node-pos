import { UserDatasource } from "../../user";
import { AuthDatasource } from "../datasource/auth.datasource";
import { AuthResponseDto, LoginRequestDto } from "../dto";

interface ResponseLogin {
    token: string;
    user: {
        id: number;
        name: string;
        email: string;
        img?: string;
    };
    permissions: string[];
}

export class LoginUseCase {
    constructor(
        private authDatasource = new AuthDatasource(),
        private userDatasource = new UserDatasource(),
    ) {
        this.authDatasource = authDatasource;
        this.userDatasource = userDatasource;
    }
    async execute(login: LoginRequestDto ): Promise<ResponseLogin> {
        const auth = await this.authDatasource.login(login);
        const user = await this.userDatasource.getPermissions(auth.user.id);
        return {
            token: auth.token,
            user: auth.user,
            permissions: user.permissions,
        };
    }
}   