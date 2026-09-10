import { UserDatasource } from "../datasource/user.datasource";

export class DeleteUserUsecase {

    public async execute(id: number): Promise<boolean> {
        return await new UserDatasource().delete(id);
    }
}