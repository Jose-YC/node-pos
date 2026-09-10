import { PermissionRaw } from "../../permission/interface/permission.interface";

export interface RoleRaw {
  id: number;
  name: string;
  description: string | null;
  permissions: number;
}

export interface RoleByIdRaw {
  id: number;
  name: string;
  description: string | null;
  permissions: PermissionRaw[];
}