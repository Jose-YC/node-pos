import { BoxClosedDatasource } from "../datasource/box-closed.datasource";
import { CreateBoxClosedRequestDto } from "../dto";

export class ClosedBoxUsecase {

    public async execute(options: CreateBoxClosedRequestDto): Promise<boolean> {
        return await new BoxClosedDatasource().closed(options);
    }
}