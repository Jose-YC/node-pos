import { AsyncLocalStorage } from 'async_hooks';
import { UserPermissionsResponseDto } from '../../modules/user/dto';

class UserContextManager {
  private static instance: UserContextManager;
  private asyncLocalStorage: AsyncLocalStorage<UserPermissionsResponseDto>;

  private constructor() {
    this.asyncLocalStorage = new AsyncLocalStorage<UserPermissionsResponseDto>();
  }

  public static getInstance(): UserContextManager {
    if (!UserContextManager.instance) {
      UserContextManager.instance = new UserContextManager();
    }
    return UserContextManager.instance;
  }

  public run<T>(context: UserPermissionsResponseDto, callback: () => T): T {
    return this.asyncLocalStorage.run(context, callback);
  }

  public getContext(): UserPermissionsResponseDto | null {
    const context = this.asyncLocalStorage.getStore();
    return context ?? null;
  }

  public hasContext(): boolean {
    return this.getContext() !== null;
  }

  public getUserId(): number | null {
    const context = this.getContext();
    return context?.id ?? null;
  }

  public getValue<K extends keyof UserPermissionsResponseDto>(key: K): UserPermissionsResponseDto[K] | null {
    const context = this.getContext();
    return context?.[key] ?? null;
  }
}

// Exportar instancia única para usar en toda la aplicación
export const userContextManager = UserContextManager.getInstance();
