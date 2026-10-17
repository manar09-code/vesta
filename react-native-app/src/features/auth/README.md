# Authentication

Authentication screens call a controller; controllers call repositories in `src/data/`; repositories access Firebase. Screens never access Firebase directly. The current auth state is a placeholder.
