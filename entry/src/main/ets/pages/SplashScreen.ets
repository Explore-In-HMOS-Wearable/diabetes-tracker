import { loadUser, initPreferences } from '../utils/PreferencesManager'
import { getGlobalContext } from '../entryability/EntryAbility';
import { common } from '@kit.AbilityKit';
import { User } from '../types/User';
import { sendDailyMeasurementNotification, getPermission } from '../services/NotificationService'

@Entry
@Component
struct SplashScreen {
  @Provide pathStack: NavPathStack = new NavPathStack()
  private context: common.UIAbilityContext = getGlobalContext();
  private currentUser: User | null = null

  async aboutToAppear(): Promise<void> {
    await initPreferences(this.context)
    await getPermission(this.context)
    sendDailyMeasurementNotification()
    this.currentUser = await loadUser();
    if(!this.currentUser) {
      this.pathStack.pushPathByName('RegistrationPage',null)
    } else {
      this.pathStack.pushPathByName('Index',null)
    }
  }

  build() {
    Navigation(this.pathStack) {
      Column() {
        LoadingProgress()
      }
    }
    .mode(NavigationMode.Stack)
  }

}