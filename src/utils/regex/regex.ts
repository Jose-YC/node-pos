export const REGEX_PATTERNS = {
  EMAIL: /^[a-zA-Z0-9_%+-]+(\.[a-zA-Z0-9_%+-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z]{2,}$/,
  PASSWORD_STRONG: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$\!%*?&])\S{6,}$/,
  DNI: /^\d{8}$/,
  CE: /^[A-Z0-9]{4,12}$/,
  PAS: /^[A-Z0-9]{5,12}$/,
  PHONE:/^\+?\d{7,15}$/,
};