export const typeDocSale = (typeIdentity: string | undefined): string => {
    switch (typeIdentity) {
        case 'RUC':
            return '01';
        default:
            return'03';
    }
}

export const validatorNumber = (type: string, number: string): string | null => {
  switch (type) {
    case 'RUC': // RUC
      if (!validatorRUC(number)) {
          return "El RUC debe tener 11 caracteres validos"
      }
      return null;

    case 'DNI': // DNI
      if (!/^\d{8}$/.test(number)) {
        return "El DNI debe tener exactamente 8 dígitos numéricos"
      }
      return null;
    
    case 'CE': // CE
      if (!/^[A-Za-z0-9]{8,12}$/.test(number)) {
        return "El carnet de extranjeria debe tener entre 8 y 12 caracteres alfanuméricos"
      }
      return null;
  
    case 'PAS': // PAS
      if (!/^[A-Z0-9]{5,12}$/.test(number)) {
        return "El pasaporte debe tener entre 5 y 12 caracteres alfanuméricos"
      }
      return null;
    
    default:
        return "El tipo de documento seleccionado no existe"

  }
}

export const validatorRUC = (ruc: string): boolean => {
    
    if (!/^\d{11}$/.test(ruc)) return false

    const prefijosValidos = ["10", "15", "17", "20"]
    if (!prefijosValidos.includes(ruc.slice(0, 2))) return false

    const factores     = [5, 4, 3, 2, 7, 6, 5, 4, 3, 2]
    const suma         = factores.reduce((acc, f, i) => acc + f * Number(ruc[i]), 0)
    const digitoEsperado = (11 - (suma % 11)) % 10

  return digitoEsperado === Number(ruc[10])
}