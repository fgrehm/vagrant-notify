Vagrant.actions[:start].tap do |start|
  start.insert_after Vagrant::Action::VM::Boot,                Vagrant::Notify::Middleware::StartServer
  start.insert_after Vagrant::Notify::Middleware::StartServer, Vagrant::Notify::Middleware::InstallCommand
end
Vagrant.actions[:resume].tap do |start|
  start.use Vagrant::Notify::Middleware::StartServer
  start.use Vagrant::Notify::Middleware::InstallCommand
end
Vagrant.actions[:halt].use      Vagrant::Notify::Middleware::StopServer
Vagrant.actions[:suspend].use   Vagrant::Notify::Middleware::StopServer
Vagrant.actions[:provision].use Vagrant::Notify::Middleware::InstallCommand
