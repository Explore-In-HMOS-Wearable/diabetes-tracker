import { dataManager } from '../utils/DataManager';
import { loadUser } from '../utils/PreferencesManager';
import { User } from '../types/User'
import { Measurement } from '../types/Measurement'

@Builder
export function UserPageBuilder() {
  UserPage()
}

@Component
struct UserPage {

  @Consume pathStack: NavPathStack
  private currentUser : User | null = null
  @State measurementList: Measurement[] = []

  async aboutToAppear() {
    this.currentUser = await loadUser();
    this.measurementList = await dataManager.getAllMeasurements()
  }

  build() {
    NavDestination() {
      Column() {
        Blank().height('35px')
        Text('Measurements')
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)

        if (this.measurementList.length === 0) {
          Text('No Measurement Yet')
            .fontSize(16)
            .fontColor('#888888')
            .textAlign(TextAlign.Center)
        } else {
          List({ space: 10 }) {
            ForEach(this.measurementList, (item: Measurement, index: number) => {
              ListItem() {
                Row() {
                  Column() {
                    Text(`${item.type}`)
                      .fontSize(22)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                    Blank().height('5px')
                    Text(`${item.value}`)
                      .fontSize(18)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)

                  }
                  .alignItems(HorizontalAlign.Start)

                  Text(item.date)
                    .fontSize(12)
                    .fontColor('#666666')
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .padding(15)
                .backgroundColor('#2A2A2A')
                .borderRadius(12)
              }
            }, (item: Measurement, index: number) => {
              return JSON.stringify(item);
            })
          }
          .layoutWeight(1)
          .width('100%')
          .padding(10)
        }
      }.width('100%').height('100%')
    }.hideTitleBar(true)
  }

}