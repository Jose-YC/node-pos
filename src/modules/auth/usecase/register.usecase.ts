import { AuthDatasource } from "../datasource/auth.datasource";
import { RegisterRequestDto, AuthResponseDto } from "../dto";

export class RegisterUseCase {

    execute(register: RegisterRequestDto): Promise<AuthResponseDto> {
        return new AuthDatasource().register(register);
    }
}