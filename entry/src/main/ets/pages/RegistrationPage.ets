import { User } from '../types/User';
import { saveUser } from '../utils/PreferencesManager';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Builder
export function RegistrationPageBuilder() {
  RegistrationPage()
}

@Component
struct RegistrationPage {
  @State name: string = '';
  @State diabetesType : string = ''
  private diagnosisDate: Date = new Date();
  @State dailyInsulinNeeded: number = 0;
  @State dailyMedication: number = 0;
  @Consume pathStack: NavPathStack
  private showDatePicker: boolean = false;


  private async saveUser () {
    if (!this.name.trim()) {
      promptAction.openToast({ message: 'Please fill all fields' });
      return;
    }

    const user : User = {
      name: this.name,
      diabetesType: this.diabetesType,
      dailyInsulinNeed: this.dailyInsulinNeeded,
      medication: this.dailyMedication
    }

    try {
      await saveUser(user).then(() => {
        promptAction.openToast({
          message: `User created successfully`,
          duration: 2000
        });
        setTimeout(() => {
          this.pathStack.pushPathByName('Index',null);
        }, 1000);
      }).catch((error: BusinessError) => {
        promptAction.openToast({
          message: `${error.message}`,
          duration: 3000
        });
        console.error('Adding error:', error);
      });
    } catch (err) {

    }
  }

  private formatDate(date: Date): string {
    return `${date.getDate().toString().padStart(2, '0')}.${(date.getMonth() + 1).toString().padStart(2, '0')}.${date.getFullYear()}`;
  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Blank().height('35px')
            Column({ space: 10 }) {
              Text('Full Name')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Start)
                .margin({ left: '15%' })

              TextInput({ placeholder: 'Enter your full name' })
                .width('70%')
                .height(50)
                .fontSize(16)
                .padding(10)
                .border({ width: 1, color: Color.Gray, radius: 10 })
                .onChange((value: string) => {
                  this.name = value;
                })
            }
            Blank().height('20px')
            Column({ space: 10 }) {
              Text('Diabetes Type')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Start)
                .margin({ left: '15%' })

              TextInput({ placeholder: 'Diabates Type' })
                .width('70%')
                .height(50)
                .fontSize(16)
                .padding(10)
                .border({ width: 1, color: Color.Gray, radius: 10 })
                .onChange((value: string) => {
                  this.diabetesType = value;
                })
            }

            Blank().height('20px')
            Column({ space: 10 }) {
              Text('Daily Insulin Need (units)')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Start)
                .margin({ left: '15%' })

              Row({ space: 10 }) {
                TextInput({ text: this.dailyInsulinNeeded.toString(), placeholder: '0' })
                  .width('60%')
                  .height(50)
                  .fontSize(16)
                  .padding(10)
                  .border({ width: 1, color: Color.Gray, radius: 10 })
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    const num = parseInt(value);
                    if (!isNaN(num) && num >= 0) {
                      this.dailyInsulinNeeded = num;
                    }
                  })

                Text('units/day')
                  .fontSize(16)
              }
              .width('70%')
            }
            Blank().height('20px')
            Column({ space: 10 }) {
              Text('Daily Medication (mg)')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Start)
                .margin({ left: '15%' })

              Row({ space: 10 }) {
                TextInput({ text: this.dailyMedication.toString(), placeholder: '0' })
                  .width('60%')
                  .height(50)
                  .fontSize(16)
                  .padding(10)
                  .border({ width: 1, color: Color.Gray, radius: 10 })
                  .type(InputType.Number)
                  .onChange((value: string) => {
                    const num = parseInt(value);
                    if (!isNaN(num) && num >= 0) {
                      this.dailyMedication = num;
                    }
                  })

                Text('mg/day')
                  .fontSize(16)
              }
              .width('70%')
            }
            Blank().height('20px')
            Button('Save')
              .width('70%')
              .height(50)
              .fontSize(18)
              .backgroundColor('#007AFF')
              .onClick(() => {
                this.saveUser()
              })
              .margin({ bottom: 20 })

          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
    }.hideTitleBar(true)
  }
}