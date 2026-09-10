import z from "zod";
import { numberField, stringField } from "../../../shared";
import { modules } from "../utils/enum/image.enum";

const sanitizeFileName = (name: string) =>
      name
      .replace(/\.[^/.]+$/, '')      
      .toLowerCase()
      .replace(/\s+/g, '-');

export const CreateUploadUrlSchema = z.object({
    name: stringField()
          .transform(sanitizeFileName)
          .refine((name) => name.length > 0, {
            message: 'must contain at least one valid character after sanitization',
          }),
    userid: numberField().positive('must be a positive integer'),
    type: z.enum(modules, {
      error: (issue) => {
        if (issue.input === undefined || issue.input === null) {
          return ` is required`;
        }
        return `must be one of: ${Object.values(modules).join(', ')}`;
      },
    })
});

export type CreateUploadUrlInput = z.infer<typeof CreateUploadUrlSchema>;