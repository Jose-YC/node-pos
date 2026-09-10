
import { ClosedBoxDetailResponseDto } from "./box-closed-detail.byid";

export class ClosedBoxDResponseDto {
    constructor(
        public id: number,
        public serie: string,
        public status: string,
        public start: Date,
        public end: Date,
        public payments: ClosedBoxDetailResponseDto[],
        public notes?: string,
    ){}
}