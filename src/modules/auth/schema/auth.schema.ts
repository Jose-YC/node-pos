import { z } from 'zod';
import { REGEX_PATTERNS } from '../../../utils';

const stringField = () => z.string({
    error: (issue) => {
        if (issue.code === 'invalid_type') {
            if (issue.input === undefined || issue.input === null) {
                return `is required`;
            }
            return `must be a string`;
        }
    }
}).trim().min(1, `cannot be empty`);


export const LoginRequestSchema = z.object({
    email: stringField().regex(REGEX_PATTERNS.EMAIL, "must be a valid email address"),
    password: stringField()
});

export type LoginRequestInput = z.infer<typeof LoginRequestSchema>;