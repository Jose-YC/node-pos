import { PermissionDatasource } from "../datasource/permission.datasource";

export class DeletePermissionUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new PermissionDatasource().delete(id);
    }
}