import React, { useState, useMemo } from 'react'
import { Head, useForm, router } from '@inertiajs/react'
import AppLayout from '../../layouts/AppLayout'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { Card, CardContent, CardFooter } from '../../components/ui/card'
import { Checkbox } from '../../components/ui/checkbox'
import { Trash2, Loader2 } from 'lucide-react'
import { cn } from '../../lib/utils'
import type { Todo, FilterType, TodosIndexProps } from '../../types'

// TodoItem Component
interface TodoItemProps {
  todo: Todo
}

function TodoItem({ todo }: TodoItemProps) {
  const [isEditing, setIsEditing] = useState(false)
  const [editTitle, setEditTitle] = useState(todo.title)

  const handleToggle = () => {
    router.patch(`/todos/${todo.id}/toggle`, {}, { preserveScroll: true })
  }

  const handleDelete = () => {
    router.delete(`/todos/${todo.id}`, { preserveScroll: true })
  }

  const handleUpdate = () => {
    const trimmed = editTitle.trim()
    if (trimmed && trimmed !== todo.title) {
      router.patch(`/todos/${todo.id}`, { todo: { title: trimmed } }, { preserveScroll: true })
    } else {
      setEditTitle(todo.title)
    }
    setIsEditing(false)
  }

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') {
      handleUpdate()
    } else if (e.key === 'Escape') {
      setEditTitle(todo.title)
      setIsEditing(false)
    }
  }

  if (isEditing) {
    return (
      <div className="flex items-center gap-3 rounded-lg border border-slate-700 bg-slate-800/50 p-4">
        <Input
          type="text"
          value={editTitle}
          onChange={(e) => setEditTitle(e.target.value)}
          onKeyDown={handleKeyDown}
          onBlur={handleUpdate}
          autoFocus
          className="flex-1 border-rose-500 bg-slate-900 text-white"
        />
        <Button size="sm" onClick={handleUpdate}>
          Save
        </Button>
      </div>
    )
  }

  return (
    <div
      className={cn(
        'group flex items-center gap-4 rounded-lg border p-4 transition-all duration-200',
        todo.completed
          ? 'border-slate-800 bg-slate-900/30'
          : 'border-slate-700 bg-slate-800/50 hover:border-rose-500/50'
      )}
    >
      <Checkbox
        checked={todo.completed}
        onCheckedChange={handleToggle}
        className="h-5 w-5 border-2"
      />
      <span
        onDoubleClick={() => setIsEditing(true)}
        className={cn(
          'flex-1 cursor-pointer transition-colors',
          todo.completed ? 'text-slate-500 line-through' : 'text-slate-200'
        )}
        title="Double-click to edit"
      >
        {todo.title}
      </span>
      <Button
        variant="ghost"
        size="icon"
        onClick={handleDelete}
        data-testid="delete-todo"
        className="delete-todo text-slate-400 opacity-0 transition-opacity group-hover:opacity-100 hover:bg-red-400/10 hover:text-red-400"
      >
        <Trash2 className="h-4 w-4" />
      </Button>
    </div>
  )
}

// TodoForm Component
function TodoForm() {
  const { data, setData, post, processing, reset } = useForm({
    title: '',
  })

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (data.title.trim()) {
      post('/todos', {
        preserveScroll: true,
        onSuccess: () => reset(),
      })
    }
  }

  return (
    <form onSubmit={handleSubmit} className="flex gap-3 p-4">
      <Input
        type="text"
        placeholder="What needs to be done?"
        value={data.title}
        onChange={(e) => setData('title', e.target.value)}
        disabled={processing}
        className="h-12 flex-1 border-slate-700 bg-slate-800/50 text-white placeholder:text-slate-500 focus:border-rose-500"
      />
      <Button
        type="submit"
        disabled={processing || !data.title.trim()}
        className="h-12 bg-rose-500 px-6 font-semibold text-white hover:bg-rose-600"
      >
        {processing ? <Loader2 className="h-4 w-4 animate-spin" /> : 'Add'}
      </Button>
    </form>
  )
}

// TodoFilters Component
interface TodoFiltersProps {
  filter: FilterType
  onFilterChange: (filter: FilterType) => void
  activeCount: number
  completedCount: number
}

function TodoFilters({ filter, onFilterChange, activeCount, completedCount }: TodoFiltersProps) {
  const filters: { value: FilterType; label: string }[] = [
    { value: 'all', label: 'All' },
    { value: 'active', label: 'Active' },
    { value: 'completed', label: 'Completed' },
  ]

  const handleClearCompleted = () => {
    router.delete('/todos/clear_completed', { preserveScroll: true })
  }

  return (
    <div className="flex flex-wrap items-center justify-between gap-4 text-sm">
      <span className="text-slate-500">
        {activeCount} item{activeCount !== 1 ? 's' : ''} left
      </span>

      <div className="flex gap-1">
        {filters.map(({ value, label }) => (
          <Button
            key={value}
            variant={filter === value ? 'default' : 'ghost'}
            size="sm"
            onClick={() => onFilterChange(value)}
            className={cn(
              'text-xs',
              filter === value
                ? 'bg-rose-500 text-white hover:bg-rose-600'
                : 'text-slate-400 hover:bg-slate-700 hover:text-white'
            )}
          >
            {label}
          </Button>
        ))}
      </div>

      {completedCount > 0 && (
        <Button
          variant="ghost"
          size="sm"
          onClick={handleClearCompleted}
          className="text-xs text-slate-500 underline underline-offset-2 hover:text-red-400"
        >
          Clear completed ({completedCount})
        </Button>
      )}
    </div>
  )
}

// Main Index Page Component
export default function Index({ todos }: TodosIndexProps) {
  const [filter, setFilter] = useState<FilterType>('all')

  const filteredTodos = useMemo(() => {
    switch (filter) {
      case 'active':
        return todos.filter((t) => !t.completed)
      case 'completed':
        return todos.filter((t) => t.completed)
      default:
        return todos
    }
  }, [todos, filter])

  const activeCount = todos.filter((t) => !t.completed).length
  const completedCount = todos.filter((t) => t.completed).length

  return (
    <AppLayout>
      <Head title="Todos" />

      <Card className="border-slate-800 bg-slate-900/50 backdrop-blur-sm">
        <CardContent className="space-y-6 p-6">
          <TodoForm />

          {filteredTodos.length === 0 ? (
            <div className="py-12 text-center">
              <p className="text-slate-500">
                {filter === 'all' ? 'No todos yet. Add one above!' : `No ${filter} todos.`}
              </p>
            </div>
          ) : (
            <div className="space-y-2">
              {filteredTodos.map((todo) => (
                <TodoItem key={todo.id} todo={todo} />
              ))}
            </div>
          )}
        </CardContent>

        {todos.length > 0 && (
          <CardFooter className="border-t border-slate-800 p-4">
            <div className="w-full">
              <TodoFilters
                filter={filter}
                onFilterChange={setFilter}
                activeCount={activeCount}
                completedCount={completedCount}
              />
            </div>
          </CardFooter>
        )}
      </Card>
    </AppLayout>
  )
}
