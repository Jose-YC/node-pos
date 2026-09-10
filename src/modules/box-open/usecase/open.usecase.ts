import { BoxOpenDatasource } from "../datasource/box-open.datasource";
import { CreateBoxOpenRequestDto } from "../dto";

export class OpenBoxUsecase {

    public async execute(options: CreateBoxOpenRequestDto): Promise<boolean> {
        return await new BoxOpenDatasource().open(options);
    }
}