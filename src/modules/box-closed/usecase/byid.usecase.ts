import { BoxClosedDatasource } from "../datasource/box-closed.datasource";
import { ClosedBoxDResponseDto } from "../dto";

export class ByIdBoxClosedUsecase {

    public async execute(id: number): Promise<ClosedBoxDResponseDto> {
        return await new BoxClosedDatasource().getId(id);
    }
}