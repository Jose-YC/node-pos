export interface PermissionRaw {
  id: number;
  name: string;
  module: string;
  description: string | null;
}

export interface PermissionOptionsRaw {
  id: number;
  name: string;
}