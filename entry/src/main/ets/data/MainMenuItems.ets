import {MainMenuItem} from '../types/MainMenuItem'

export const mainMenuItems: MainMenuItem[] = [
  {
    icon: $r('app.media.healthData'),
    name: 'Diabetic Metrics',
    pageName: 'UserPage'
  },
  {
    icon: $r('app.media.add'),
    name: 'Add Measurement',
    pageName: 'MeasurementPage'
  }
]
