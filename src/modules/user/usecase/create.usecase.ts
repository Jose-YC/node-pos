import { UserDatasource } from "../datasource/user.datasource";
import { CreateUserRequestDto } from "../dto";

export class CreateUserUsecase {

    public async execute(options: CreateUserRequestDto): Promise<boolean> {
        return await new UserDatasource().create(options);
    }
}