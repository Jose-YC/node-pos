import { AuthDatasource } from "../datasource/auth.datasource";
import { AuthResponseDto, LoginRequestDto } from "../dto";

export class LoginUseCase {

    execute(login: LoginRequestDto): Promise<AuthResponseDto> {
        return new AuthDatasource().login(login);
    }
}   