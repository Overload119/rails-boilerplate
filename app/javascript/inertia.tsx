import React from 'react'
import { createRoot } from 'react-dom/client'
import { createInertiaApp } from '@inertiajs/react'

// Import all pages explicitly (Bun doesn't support import.meta.glob)
import TodosIndex from './pages/Todos/Index'
import StorybooksIndex from './pages/Storybooks/Index'

// eslint-disable-next-line @typescript-eslint/no-explicit-any
const pages: Record<string, React.ComponentType<any>> = {
  'Todos/Index': TodosIndex,
  'Storybooks/Index': StorybooksIndex,
}

createInertiaApp({
  resolve: (name) => {
    const page = pages[name]
    if (!page) {
      throw new Error(`Page not found: ${name}`)
    }
    return { default: page }
  },
  setup({ el, App, props }) {
    const root = createRoot(el)
    root.render(
      <React.StrictMode>
        <App {...props} />
      </React.StrictMode>
    )
  },
  progress: {
    color: '#e94560',
    showSpinner: true,
  },
})
