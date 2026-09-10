import { SaleDatasource } from "../datasource/sale.datasource";
import { CreateCreditNoteRequestDto } from "../dto";

export class CreateCreditNoteUsecase {

    public async execute(options: CreateCreditNoteRequestDto): Promise<boolean> {
        return await new SaleDatasource().creditNote(options);
    }
}