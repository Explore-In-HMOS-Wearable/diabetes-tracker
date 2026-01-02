import preferences from '@ohos.data.preferences';
import { User } from '../types/User';

const PREF_NAME = 'diabetes_pref';
let diabetesPrefs: preferences.Preferences | null = null;
let isInitialized: boolean = false;
const USER_KEY = 'current_user';

export async function initPreferences(context: Context): Promise<boolean> {
  try {
    diabetesPrefs = await preferences.getPreferences(context, PREF_NAME);
    isInitialized = true;
    return true;
  } catch (err) {
    return false;
  }
}

export async function saveUser(user: User): Promise<boolean> {
  if (!diabetesPrefs || !isInitialized) {
    return false;
  }

  try {
    const userJson = JSON.stringify({
      name: user.name,
      diabetesType: user.diabetesType,
      dailyInsulinNeed: user.dailyInsulinNeed,
      medication: user.medication
    });

    await diabetesPrefs.put(USER_KEY, userJson);
    await diabetesPrefs.flush();
    return true;

  } catch (err) {
    return false;
  }
}

export async function loadUser(): Promise<User | null> {
  if (!diabetesPrefs || !isInitialized) {
    return null;
  }

  try {
    const userJson: string = await diabetesPrefs.get(USER_KEY, '') as string;
    if (!userJson || userJson === '') {
      return null;
    }
    const parsedData = JSON.parse(userJson) as User;

    const user: User = {
      name: parsedData.name,
      diabetesType: parsedData.diabetesType,
      dailyInsulinNeed: parsedData.dailyInsulinNeed,
      medication: parsedData.medication
    }

    return user;

  } catch (err) {
    return null;
  }
}
