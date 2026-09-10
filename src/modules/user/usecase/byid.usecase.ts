import { UserDatasource } from "../datasource/user.datasource";
import { UserResponseDto } from "../dto";

export class ByIdUserUsecase {

    public async execute(id: number): Promise<UserResponseDto> {
        return await new UserDatasource().getId(id);
    }
}