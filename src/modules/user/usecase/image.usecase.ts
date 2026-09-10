import { UserDatasource } from "../datasource/user.datasource";
import { UpdateImageRequestDto } from "../dto";


export class ImageUserUsecase {

    public async execute (update: UpdateImageRequestDto): Promise<boolean> {
        return await new UserDatasource().image(update);
    }

}