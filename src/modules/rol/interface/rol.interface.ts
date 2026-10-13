import { PermissionRaw } from "../../permission/interface/permission.interface";

export interface RoleRaw {
  id: number;
  name: string;
  permissions: number;
}

export interface RoleByIdRaw {
  id: number;
  name: string;
  description: string | null;
  permissions: PermissionRaw[];
}

export interface RoleOptionsRaw {
  id: number;
  name: string;
}