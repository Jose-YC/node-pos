import { DOCUMENTE_TYPE_NAME } from './../../../shared';
import { typeDocSale } from "../../../utils";
import { SaleDatasource } from "../datasource/sale.datasource";
import { CreateSaleRequestDto } from "../dto";

export class CreateSaleUsecase {

    public async execute(options: CreateSaleRequestDto): Promise<boolean> {
        const customerType = options.customer?.customer_type;
        const type_doc_sale = typeDocSale(
            customerType ? DOCUMENTE_TYPE_NAME[customerType] : undefined
        );

        return await new SaleDatasource().create(options, type_doc_sale);
    }
}