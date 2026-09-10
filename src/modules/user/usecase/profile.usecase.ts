import { UserDatasource } from "../datasource/user.datasource";
import { UpdateProfileRequestDto } from "../dto";

export class ProfileUserUsecase {

    public async execute(updateProfile: UpdateProfileRequestDto): Promise<boolean> {
        return await new UserDatasource().profile(updateProfile);
    }
}