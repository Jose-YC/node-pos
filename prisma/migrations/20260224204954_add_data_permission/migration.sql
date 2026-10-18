INSERT INTO permission (name, description, module, updated_at)
VALUES
    -- Type Document Sale
    ('type-document-sale:read', 'Leer tipo de documento de venta', 'Type Document Sale', NOW()),
    ('type-document-sale:read-status', 'Leer tipo de documento de venta activos', 'Type Document Sale', NOW()),
    ('type-document-sale:update-status', 'Actualizar el estado del tipo de documento de venta', 'Type Document Sale', NOW()),

    -- Identity Document Type
    ('identity-document-type:read', 'Leer los tipos de documentos de identidad personal', 'Identity Document Type', NOW()),

    -- Users
    ('users:create', 'Crear usuarios', 'users', NOW()),
    ('users:read', 'Leer usuarios', 'users', NOW()),
    ('users:byid', 'Leer usuarios por ID', 'users', NOW()),
    ('users:update', 'Actualizar usuarios', 'users', NOW()),
    ('users:profile', 'Actualizar perfil y contraseña', 'users', NOW()),
    ('users:delete', 'Eliminar usuarios', 'users', NOW()),

    -- Roles
    ('roles:create', 'Crear roles', 'roles', NOW()),
    ('roles:read', 'Leer roles', 'roles', NOW()),
    ('roles:options', 'Mostrar roles para seleccionar', 'roles', NOW()),
    ('roles:byid', 'Leer roles por ID', 'roles', NOW()),
    ('roles:update', 'Actualizar roles', 'roles', NOW()),
    ('roles:delete', 'Eliminar roles', 'roles', NOW()),

    -- Permissions
    ('permissions:create', 'Crear permisos', 'permissions', NOW()),
    ('permissions:read', 'Leer permisos', 'permissions', NOW()),
    ('permissions:options', 'Mostrar permisos para seleccionar', 'permissions', NOW()),
    ('permissions:byid', 'Leer permisos por ID', 'permissions', NOW()),
    ('permissions:update', 'Actualizar permisos', 'permissions', NOW()),
    ('permissions:delete', 'Eliminar permisos', 'permissions', NOW()),

    -- Categories
    ('categories:create', 'Crear categorías', 'categories', NOW()),
    ('categories:read', 'Leer categorías', 'categories', NOW()),
    ('categories:options', 'Mostrar categorías para seleccionar', 'categories', NOW()),
    ('categories:byid', 'Leer categorías por ID', 'categories', NOW()),
    ('categories:update', 'Actualizar categorías', 'categories', NOW()),
    ('categories:delete', 'Eliminar categorías', 'categories', NOW()),

    -- Suppliers
    ('suppliers:create', 'Crear proveedor', 'suppliers', NOW()),
    ('suppliers:read', 'Leer proveedor', 'suppliers', NOW()),
    ('suppliers:byid', 'Leer proveedor por ID', 'suppliers', NOW()),
    ('suppliers:update', 'Actualizar proveedor', 'suppliers', NOW()),
    ('suppliers:delete', 'Eliminar proveedor', 'suppliers', NOW()),

    -- Customers
    ('customers:create', 'Crear cliente', 'customers', NOW()),
    ('customers:read', 'Leer cliente', 'customers', NOW()),
    ('customers:byid', 'Leer cliente por ID', 'customers', NOW()),
    ('customers:update', 'Actualizar cliente', 'customers', NOW()),
    ('customers:delete', 'Eliminar cliente', 'customers', NOW()),

    -- Payments
    ('payments:create', 'Crear metodo de pago', 'payments', NOW()),
    ('payments:read', 'Leer metodo de pago', 'payments', NOW()),
    ('payments:options', 'Mostrar metodos de pago para seleccionar', 'payments', NOW()),
    ('payments:status', 'Cambiar estado de un metodo de pago', 'payments', NOW()),
    ('payments:byid', 'Leer metodo de pago por ID', 'payments', NOW()),
    ('payments:update', 'Actualizar metodo de pago', 'payments', NOW()),
    ('payments:delete', 'Eliminar metodo de pago', 'payments', NOW()),

    -- Products
    ('products:create', 'Crear producto', 'products', NOW()),
    ('products:read', 'Leer producto', 'products', NOW()),
    ('products:read-catalog', 'Leer catalogo de productos', 'products', NOW()),
    ('products:byid', 'Leer producto por ID', 'products', NOW()),
    ('products:update', 'Actualizar producto', 'products', NOW()),
    ('products:status', 'Actualizar estado del producto', 'products', NOW()),
    ('products:delete', 'Eliminar producto', 'products', NOW()),

    -- Purchase
    ('purchase:create', 'Crear orden de compra', 'purchase', NOW()),
    ('purchase:read', 'Leer orden de compra', 'purchase', NOW()),
    ('purchase:byid', 'Leer orden de compra por ID', 'purchase', NOW()),
    ('purchase:update', 'Actualizar orden de compra', 'purchase', NOW()),
    ('purchase:draft', 'Actualizar a borrador una orden de compra', 'purchase', NOW()),
    ('purchase:send', 'Enviar al proveedor una orden de compra', 'purchase', NOW()),
    ('purchase:submit', 'Orden de compra aceptada por el proveedor', 'purchase', NOW()),
    ('purchase:delete', 'Eliminar orden de compra', 'purchase', NOW()),

    -- Receipt
    ('receipt:create', 'Crear recepcion de compra', 'receipt', NOW()),
    ('receipt:read', 'Leer recepcion de compra', 'receipt', NOW()),
    ('receipt:byid', 'Leer recepcion de compra por ID', 'receipt', NOW()),
    ('receipt:update', 'Actualizar recepcion de compra', 'receipt', NOW()),
    ('receipt:submit', 'Confirmar recepcion de compra', 'receipt', NOW()),
    ('receipt:delete', 'Eliminar recepcion de compra', 'receipt', NOW()),

    -- Box
    ('box-open:create', 'Abrir una caja de compra', 'box', NOW()),
    ('box-closed:create', 'Cerrar una caja de compra por ID', 'box', NOW()),
    ('box-closed:byid', 'Leer caja de compra por ID', 'box', NOW()),

    -- Sale
    ('sale:create', 'Crear una venta', 'sale', NOW()),
    ('sale:byid', 'Leer una venta', 'sale', NOW()),
    ('sale:readid', 'Leer tus ventas', 'sale', NOW()),
    ('sale:read', 'Leer todas las ventas', 'sale', NOW()),

    -- Credit Note
    ('credit-note:create', 'Crear una nota de credito', 'credit note', NOW()),

    -- Stock Adjustment
    ('stock-adjustment:create', 'Crear ajuste de stock', 'stock adjustment', NOW()),
    ('stock-adjustment:read', 'Leer ajustes de stock', 'stock adjustment', NOW()),
    ('stock-adjustment:byid', 'Leer ajuste de stock por ID', 'stock adjustment', NOW()),
    ('stock-adjustment:update', 'Actualizar ajuste de stock', 'stock adjustment', NOW()),
    ('stock-adjustment:submit', 'Confirmar ajuste de stock', 'stock adjustment', NOW()),
    ('stock-adjustment:delete', 'Eliminar ajuste de stock', 'stock adjustment', NOW())
ON CONFLICT (name) DO NOTHING;	