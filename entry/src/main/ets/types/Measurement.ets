
export interface Measurement {
  type: string;
  value: number;
  unit: string; // 'mg/dL', 'units', 'grams'
  timestamp: number;
  date: string,
  notes?: string;
}
