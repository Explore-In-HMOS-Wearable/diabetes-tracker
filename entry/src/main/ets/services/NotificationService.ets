import { reminderAgentManager } from '@kit.BackgroundTasksKit'
import { notificationManager } from '@kit.NotificationKit'
import { common, wantAgent } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { vibrator } from '@kit.SensorServiceKit'

export function sendDailyMeasurementNotification(): void {

  const wantAgentInfo: wantAgent.WantAgentInfo = {
    wants: [
      {
        bundleName: 'com.hmosdemos.wearable.diabetesTracker',
        abilityName: 'EntryAbility'
      }
    ],
    actionType: wantAgent.OperationType.START_ABILITY,
    requestCode: 0,
    wantAgentFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
  }

  wantAgent.getWantAgent(wantAgentInfo, async (_err: BusinessError) => {
    const reminder: reminderAgentManager.ReminderRequestAlarm = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,
      hour: 14,
      minute: 50,
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      actionButton: [
        {
          title: 'Close',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        }
      ],
      wantAgent: {
        pkgName: wantAgentInfo?.wants[0]?.bundleName ?? '',
        abilityName: wantAgentInfo?.wants[0]?.abilityName ?? ''
      },
      ringDuration: 10,
      title: 'Daily Measurement',
      content: `Please Dont Forget Your Measurements`,
      notificationId: 2024,
      slotType: notificationManager.SlotType.SERVICE_INFORMATION
    }

    try {
      const reminderId = await reminderAgentManager.publishReminder(reminder)
      try {
        if (reminderId) {
          await vibrator.startVibration({ type: 'time', duration: 2000 }, { usage: 'physicalFeedback' })
        }
      } catch (err) {
      }
    } catch (err) {
    }
  })
}

export async function getPermission(context: common.UIAbilityContext): Promise<void> {
  notificationManager.isNotificationEnabled().then((data: boolean) => {
    if (!data) {
      notificationManager.requestEnableNotification(context).then(() => {
      }).catch((err : BusinessError) => {
        if (1600004 === err.code) {
          //
        } else {
          //
        }
      });
    }
  }).catch((err : BusinessError) => {
    //
  });
}
