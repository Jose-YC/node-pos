import { UserDatasource } from "../datasource/user.datasource";
import { UpdatePasswordRequestDto } from "../dto";

export class UpdatePasswordUserUsecase {

    public async execute(updatePassword: UpdatePasswordRequestDto): Promise<boolean> {
        return await new UserDatasource().password(updatePassword);
    }
}