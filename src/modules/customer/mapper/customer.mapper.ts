import { CustomerResponseDto } from "../dto";
import { CustomerRaw } from "../interface/customer.interface";

export class CustomerMapper {
    static toResponseDto(Customer: CustomerRaw): CustomerResponseDto {
      return {
        id: Customer.id,
        name: Customer.name,
        doc_code: Customer.doc_code,
        doc_type: Customer.doc_type,
        doc_number: Customer.doc_number,
        email: Customer.email,
        phone: Customer.phone
      };
    }

    static toResponseDtoList(Customers: CustomerRaw[]): CustomerResponseDto[] {
        return Customers.map(Customer => this.toResponseDto(Customer));
    }
}