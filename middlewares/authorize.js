const { User, Role, Permission } = require('../models');

const authorize = (requiredPermission) => {
    return async (req, res, next) => {
        try {
            const userId = req.user.id;
            const user = await User.findByPk(userId, {
                include: {
                    model: Role,
                    required: true,
                    include: {
                        model: Permission,
                        where: { permission: requiredPermission }
                    }
                }
            });
            if (!user || !user.Role || user.Role.Permissions.length === 0) {
                return res.status(403).json({ message: 'Access denied' });
            }
            next();
        } catch (error) {
            console.error('Authorization error:', error);
            res.status(500).json({ message: 'Internal server error' });
        }
    };
};

module.exports = authorize;