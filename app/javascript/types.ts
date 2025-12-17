// Inertia shared props types
export interface FlashMessages {
  success?: string
  error?: string
  info?: string
}

export interface AppMeta {
  name: string
  version: string
}

export interface SharedProps {
  flash: FlashMessages
  app: AppMeta
}

// Todo types
export interface Todo {
  id: number
  title: string
  completed: boolean
  position: number
  created_at: string
  updated_at: string
}

export type FilterType = 'all' | 'active' | 'completed'

// Page props for Todos/Index
export interface TodosIndexProps extends SharedProps {
  todos: Todo[]
}
