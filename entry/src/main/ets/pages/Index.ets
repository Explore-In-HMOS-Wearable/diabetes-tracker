import {mainMenuItems} from '../data/MainMenuItems';
import {MainMenuItem} from '../types/MainMenuItem';
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent, LengthMetrics, promptAction, UIContext } from '@kit.ArkUI';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Builder
function buildText() {
  Text('Welcome')
    .fontSize('36px')
    .fontWeight(FontWeight.Bold)
}

@Builder
export function IndexBuilder() {
  Index()
}

@Component
struct Index {

  @Consume pathStack: NavPathStack
  @State mainMenuItems: MainMenuItem[] = mainMenuItems
  private watchSize: string = '466px'
  private listSize: string = '410px'
  private context2 = this.getUIContext().getHostContext() as common.UIAbilityContext;
  context: UIContext = this.getUIContext()
  tabBar1: ComponentContent<Object> = new ComponentContent(this.context, wrapBuilder(buildText));


  build() {
    NavDestination() {
      Column() {
        Stack() {
          ArcList({ initialIndex: 0, header: this.tabBar1 }) {
            ForEach(this.mainMenuItems, (item: MainMenuItem) => {
              ArcListItem() {
                Button({ type: ButtonType.Capsule }) {
                  Row() {
                    Image(item.icon)
                      .width('64px')
                      .height('64px')
                      .margin({ right: '12px' })
                    Text(`${item.name}`)
                      .fontSize('36px')
                      .fontColor(Color.Black)
                      .fontWeight(FontWeight.Bold)
                  }
                  .justifyContent(FlexAlign.Center)
                  .width('100%')
                }
                .width(this.listSize)
                .height('100px')
                .fontSize('24px')
                .fontColor(Color.Black)
                .fontWeight(FontWeight.Bold)
                .focusable(true)
                .opacity(0.9)
                .focusOnTouch(true)
                .backgroundColor('#f0f8ff')
              }.align(Alignment.Center).onClick(() => {
                this.pathStack.pushPathByName(`${item.pageName}`,null)
              })

            }, (item: string, index: number) => item)
          }
          .space(LengthMetrics.px(10))
          .borderRadius(this.watchSize)
          .focusable(true)
          .focusOnTouch(true)
          .defaultFocus(true)
        }
        .align(Alignment.Center)
        .width(this.watchSize)
        .height(this.watchSize)
        .border({color: Color.Black, width: 3})
        .borderRadius(this.watchSize)
      }
      .height('100%')
      .width('100%')
    }.hideTitleBar(true)
  }
}