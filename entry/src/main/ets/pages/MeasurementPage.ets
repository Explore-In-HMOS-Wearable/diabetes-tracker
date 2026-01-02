import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Measurement } from '../types/Measurement';
import { dataManager } from '../utils/DataManager';

@Builder
export function MeasurementPageBuilder() {
  MeasurementPage()
}

@Component
struct MeasurementPage {

  @State measurementType :string = ''
  @State measurementUnit : string = 'mg/dL'
  @State measurementValue : number = 0
  @State notes : string = ''
  @Consume pathStack: NavPathStack

  private formatDate(date: Date): string {
    const day = date.getDate().toString().padStart(2, '0');
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const year = date.getFullYear();
    const hours = date.getHours().toString().padStart(2, '0');
    const minutes = date.getMinutes().toString().padStart(2, '0');

    return `${day}.${month}.${year} ${hours}:${minutes}`;
  }

  private async saveMeasurement() {

    const now = new Date();
    const formattedDate = this.formatDate(now);

    const measurement : Measurement = {
      date: formattedDate,
      type: this.measurementType,
      unit: this.measurementUnit,
      value: this.measurementValue,
      notes: this.notes,
      timestamp: Date.now()
    }

    try {
      await dataManager.addMeasurement(measurement).then(() => {
        promptAction.openToast({
          message: `Measurement created successfully`,
          duration: 2000
        });
        setTimeout(() => {
          this.pathStack.pop();
        }, 1000);
      })
    } catch (err) {
      promptAction.openToast({
        message: `${err.message}`,
        duration: 3000
      });
    }

  }

  build() {
    NavDestination() {
      Column() {
        Scroll() {
          Column() {
            Blank().height('35px')
            Column({ space: 10 }) {
              Text('Type')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Start)
                .margin({ left: '15%' })

              TextInput()
                .width('70%')
                .height(50)
                .fontSize(16)
                .padding(10)
                .border({ width: 1, color: Color.Gray, radius: 10 })
                .onChange((value: string) => {
                  this.measurementType = value;
                })
            }
            .width('100%')
            Blank().height('20px')
            Column({ space: 10 }) {
              Text('Unit')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Start)
                .margin({ left: '15%' })

              TextInput()
                .width('70%')
                .height(50)
                .fontSize(16)
                .padding(10)
                .border({ width: 1, color: Color.Gray, radius: 10 })
                .onChange((value: string) => {
                  this.measurementUnit = value;
                })
            }
            .width('100%')
            Blank().height('20px')
            Column({ space: 10 }) {
              Text('Value')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Start)

              TextInput({ placeholder: 'Value' })
                .width('70%')
                .height(50)
                .fontSize(16)
                .padding(10)
                .border({ width: 1, color: Color.Gray, radius: 10 })
                .type(InputType.Number)
                .onChange((value: string) => {

                  this.measurementValue = parseInt(value);
                })
            }
            Blank().height('20px')
            Column({ space: 10 }) {
              Text('Notes')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
                .alignSelf(ItemAlign.Start)


              TextInput({ placeholder: 'Please add notes' })
                .width('70%')
                .height(50)
                .fontSize(16)
                .padding(10)
                .border({ width: 1, color: Color.Gray, radius: 10 })
                .onChange((value: string) => {
                  this.notes = value;
                })
            }
            Blank().height('20px')
            Button('Save')
              .width('70%')
              .height(50)
              .fontSize(18)
              .backgroundColor('#007AFF')
              .onClick(() => {
                this.saveMeasurement()
              })
              .margin({ bottom: 20 })

          } .width('100%')
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