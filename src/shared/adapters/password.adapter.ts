import {compareSync, genSaltSync, hashSync} from 'bcryptjs'

export class bcryptjsAdapter {
    private static readonly SALT_ROUNDS = 10;
    
    static async hash(password:string): Promise<string>{ 
        const salt = genSaltSync(this.SALT_ROUNDS);
        return hashSync(password, salt);
    }

    static async compare(password:string, hashed:string):Promise<boolean>{
        return compareSync(password, hashed);
    }
  }