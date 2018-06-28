
- 推送 `git push <远程主机名> <本地分支名>:<远程分支名>`

- 删除分支 `git branch -d iss53`

- 检出新分支 `git checkout -b hotfix `

- 从远端检出新分支 `git checkout -b featureB origin/master`

- 同步远端到本地 `git fetch —all 同步远端到本地`

- `git clone --bare .git myproject.git `

- 新建 `mkdir project.git`

- 初始化 `git init --bare`

- 现有仓库导出为裸仓库 `git clone --bare my_project my_project.git`

- 移除关联远端仓库 `git remote rm` 

- 暂存 `git stash save -a "个人信息优化暂存"`

- 打印所有操作 `git log --graph --all --decorate --oneline`

- 关联本地和远端 `git branch -u origin/app_7.3.5 app_7.3.5`

- 删除远程分支 `git push origin :app_7.3.5`
- 
<html>
<!--在这里插入内容-->
</html>


<html>
<!--在这里插入内容-->
</html>



- 设置关联追踪分支 `git branch --track experimental origin/experimental`

- 输出关联远端 `git branch -vv`

- 推送两个没有关联分支 `git pull origin master --allow-unrelated-histories`
