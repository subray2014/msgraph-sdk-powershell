### Example 1: Code snippet

```powershell
Import-Module Microsoft.Graph.Users

# A UPN can also be used as -UserId.
Remove-MgUserTodoListTaskChecklistItem -UserId $userId -TodoTaskListId $todoTaskListId -TodoTaskId $todoTaskId -ChecklistItemId $checklistItemId
```
This example shows how to use the Remove-MgUserTodoListTaskChecklistItem Cmdlet.

To learn about permissions for this resource, see the [permissions reference](/graph/permissions-reference).

