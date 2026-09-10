import { AuthDatasource } from "../datasource/auth.datasource";

export class RefreshUseCase {

    execute(token: string): Promise<string> {
        return new AuthDatasource().refresh(token);
    }
}