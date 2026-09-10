import { UserDatasource } from "../datasource/user.datasource";
import { UpdateUserRequestDto } from "../dto";

export class UpdateUserUsecase {

    public async execute(options: UpdateUserRequestDto): Promise<boolean> {
        return await new UserDatasource().update(options);
    }
}