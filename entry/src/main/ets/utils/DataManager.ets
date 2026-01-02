import relationalStore from '@ohos.data.relationalStore';
import { getGlobalContext } from '../entryability/EntryAbility';
import { common } from '@kit.AbilityKit';
import { Measurement } from '../types/Measurement';

interface StoreConfig {
  name: string;
  securityLevel: relationalStore.SecurityLevel;
  encrypt?: boolean;
}

class DataManager {

  private static instance: DataManager;

  public static getInstance(): DataManager {
    if (!DataManager.instance) {
      DataManager.instance = new DataManager();
    }
    return DataManager.instance;
  }

  private rdbStore: relationalStore.RdbStore | null = null;
  private context: common.UIAbilityContext = getGlobalContext();
  private readonly MEASUREMENT_TABLE = 'measurements';

  private readonly SQL_CREATE_MEASUREMENT_TABLE = `
    CREATE TABLE IF NOT EXISTS ${this.MEASUREMENT_TABLE} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      value REAL NOT NULL,
      unit TEXT NOT NULL,
      timestamp INTEGER NOT NULL,
      date TEXT NOT NULL,
      notes TEXT
    )
  `;

  async initializeDatabase(): Promise<void> {
    const config: StoreConfig = {
      name: 'DiabetesTracker.db',
      securityLevel: relationalStore.SecurityLevel.S1,
      encrypt: false
    };

    try {
      this.rdbStore = await relationalStore.getRdbStore(this.context, config);
      await this.rdbStore.executeSql(this.SQL_CREATE_MEASUREMENT_TABLE);
    } catch (error) {
      return;
    }
  }

  private async getRdbStore(): Promise<relationalStore.RdbStore> {
    if (!this.rdbStore) {
      await this.initializeDatabase();
    }
    return this.rdbStore!;
  }

  async addMeasurement(measurement: Measurement): Promise<void> {
    try {
      const store = await this.getRdbStore();

      const valuesBucket: relationalStore.ValuesBucket = {
        'type': measurement.type.toString(),
        'value': measurement.value,
        'unit': measurement.unit,
        'timestamp': measurement.timestamp,
        'date': measurement.date,
        'notes': measurement.notes || ''
      };

      await store.insert(this.MEASUREMENT_TABLE, valuesBucket);

    } catch (err) {
      return;
    }
  }

  async getAllMeasurements(): Promise<Measurement[]> {
    try {
      const store = await this.getRdbStore();
      const predicates = new relationalStore.RdbPredicates(this.MEASUREMENT_TABLE);
      predicates.orderByDesc('timestamp');

      const resultSet = await store.query(predicates,
        ['id', 'type', 'value', 'unit', 'timestamp', 'date', 'notes']);

      const measurements: Measurement[] = [];
      while (resultSet.goToNextRow()) {
        measurements.push({
          type: resultSet.getString(resultSet.getColumnIndex('type')),
          value: resultSet.getLong(resultSet.getColumnIndex('value')),
          unit: resultSet.getString(resultSet.getColumnIndex('unit')),
          timestamp: resultSet.getLong(resultSet.getColumnIndex('timestamp')),
          date: resultSet.getString(resultSet.getColumnIndex('date')),
          notes: resultSet.getString(resultSet.getColumnIndex('notes'))
        })
      }

      resultSet.close();
      return measurements;

    } catch (err) {
      return [];
    }
  }
}

export const dataManager = new DataManager();